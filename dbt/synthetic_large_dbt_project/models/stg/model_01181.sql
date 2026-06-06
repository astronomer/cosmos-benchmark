{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00265') }},
        {{ ref('model_00538') }}
)
select id, 'model_01181' as name from sources
