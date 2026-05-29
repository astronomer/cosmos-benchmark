{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00669') }},
        {{ ref('model_00157') }},
        {{ ref('model_00123') }}
)
select id, 'model_01487' as name from sources
