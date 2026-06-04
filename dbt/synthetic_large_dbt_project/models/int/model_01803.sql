{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01352') }},
        {{ ref('model_01251') }}
)
select id, 'model_01803' as name from sources
