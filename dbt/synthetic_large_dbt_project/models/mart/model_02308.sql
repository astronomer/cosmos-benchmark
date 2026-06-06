{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02054') }},
        {{ ref('model_01898') }}
)
select id, 'model_02308' as name from sources
