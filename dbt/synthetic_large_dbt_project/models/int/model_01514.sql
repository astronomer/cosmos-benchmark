{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01105') }},
        {{ ref('model_01209') }},
        {{ ref('model_01464') }}
)
select id, 'model_01514' as name from sources
