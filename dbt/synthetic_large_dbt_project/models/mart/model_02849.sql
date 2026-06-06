{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01717') }},
        {{ ref('model_01671') }}
)
select id, 'model_02849' as name from sources
