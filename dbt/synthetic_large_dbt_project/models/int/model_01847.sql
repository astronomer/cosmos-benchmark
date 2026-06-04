{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01353') }},
        {{ ref('model_01291') }},
        {{ ref('model_01369') }}
)
select id, 'model_01847' as name from sources
