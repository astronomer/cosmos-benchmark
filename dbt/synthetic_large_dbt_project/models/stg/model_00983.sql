{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00669') }},
        {{ ref('model_00079') }},
        {{ ref('model_00529') }}
)
select id, 'model_00983' as name from sources
