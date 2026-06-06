{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01184') }},
        {{ ref('model_01242') }}
)
select id, 'model_01888' as name from sources
