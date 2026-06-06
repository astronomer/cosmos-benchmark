{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02035') }},
        {{ ref('model_01960') }},
        {{ ref('model_02146') }}
)
select id, 'model_02258' as name from sources
