{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01798') }},
        {{ ref('model_02146') }}
)
select id, 'model_02951' as name from sources
