{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01512') }},
        {{ ref('model_01504') }},
        {{ ref('model_01834') }}
)
select id, 'model_02501' as name from sources
