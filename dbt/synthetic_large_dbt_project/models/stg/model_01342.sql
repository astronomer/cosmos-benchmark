{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00124') }},
        {{ ref('model_00025') }}
)
select id, 'model_01342' as name from sources
