{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01119') }},
        {{ ref('model_01394') }}
)
select id, 'model_01531' as name from sources
