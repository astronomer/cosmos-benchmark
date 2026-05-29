{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00425') }},
        {{ ref('model_00433') }},
        {{ ref('model_00718') }}
)
select id, 'model_00756' as name from sources
