{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01015') }},
        {{ ref('model_01392') }}
)
select id, 'model_01544' as name from sources
