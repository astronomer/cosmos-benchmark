{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02080') }},
        {{ ref('model_01561') }},
        {{ ref('model_01510') }}
)
select id, 'model_02734' as name from sources
